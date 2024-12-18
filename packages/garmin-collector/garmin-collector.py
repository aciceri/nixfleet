# !/usr/bin/env python3

import datetime
import os

from garth.exc import GarthHTTPError

from garminconnect import (
    Garmin,
    GarminConnectAuthenticationError,
)


from prometheus_client import CollectorRegistry, push_to_gateway
from prometheus_client.core import GaugeMetricFamily

email = os.getenv("GARMIN_EMAIL")
password = os.getenv("GARMIN_PASSWORD")
tokenstore = os.getenv("GARMINTOKENS") or "~/.garminconnect"
tokenstore_base64 = os.getenv("GARMINTOKENS_BASE64") or "~/.garminconnect_base64"
gateway_address = os.getenv("PUSHGATEWAY_ADDRESS")

today = datetime.date.today()


def init_api(email=email, password=password):
    """Initialize Garmin API with your credentials."""

    try:
        print(
            f"Trying to login to Garmin Connect using token data from directory '{tokenstore}'...\n"
        )

        garmin = Garmin()
        garmin.login(tokenstore)
    except (FileNotFoundError, GarthHTTPError, GarminConnectAuthenticationError):
        # Session is expired. You'll need to log in again
        print(
            "Login tokens not present, login with your Garmin Connect credentials to generate them.\n"
            f"They will be stored in '{tokenstore}' for future use.\n"
        )
        garmin = Garmin(email=email, password=password, is_cn=False)
        garmin.login()
        # Save Oauth1 and Oauth2 token files to directory for next login
        garmin.garth.dump(tokenstore)
        print(
            f"Oauth tokens stored in '{tokenstore}' directory for future use. (first method)\n"
        )
        # Encode Oauth1 and Oauth2 tokens to base64 string and safe to file for next login (alternative way)
        token_base64 = garmin.garth.dumps()
        dir_path = os.path.expanduser(tokenstore_base64)
        with open(dir_path, "w") as token_file:
            token_file.write(token_base64)
        print(
            f"Oauth tokens encoded as base64 string and saved to '{dir_path}' file for future use. (second method)\n"
        )

    return garmin


class GarminCollector:
    def __init__(self):
        super().__init__()
        self.api = init_api()

    def collect(self):
        try:
            body = self.api.get_daily_weigh_ins(today.isoformat())["totalAverage"]
            metric_gauge = GaugeMetricFamily(
                "body_composition", "Body composition and weight", labels=["metric"]
            )
            for k in [
                "weight",
                "bmi",
                "bodyFat",
                "bodyWater",
                "boneMass",
                "muscleMass",
                "physiqueRating",
                "visceralFat",
            ]:
                metric_gauge.add_metric([k], body[k])
        except Exception as e:
            print(f"Something went wrong while fetching body composition data\n{e}")

        yield metric_gauge


if __name__ == "__main__":
    registry = CollectorRegistry()
    registry.register(GarminCollector())

    push_to_gateway(gateway_address, job="garmin", registry=registry)
