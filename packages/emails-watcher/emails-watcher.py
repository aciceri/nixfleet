import os
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
from email import message_from_file
from desktop_notifier import DesktopNotifierSync, DEFAULT_SOUND, Icon


class MaildirHandler(FileSystemEventHandler):
    def __init__(self, notifier):
        super().__init__()
        self.notifier = notifier

    def on_created(self, event):
        if not event.is_directory:
            print(f"New email found: {event.src_path}")
            with open(event.src_path, 'r') as email_file:
                msg = message_from_file(email_file)
                print(f'{msg["From"]}: {msg["Subject"]}')
                self.notifier.send(
                  title=msg["From"],
                  message=msg["Subject"],
                  sound=DEFAULT_SOUND,
                  icon=Icon(name="mail-message-new"),
                  timeout=20
                )


if __name__ == "__main__":
    maildir_new = os.path.expanduser(os.environ.get("INBOX_NEW"))
    notifier = DesktopNotifierSync(
        app_name="Mails",
        notification_limit=10
    )

    event_handler = MaildirHandler(notifier)
    observer = Observer()

    observer.schedule(event_handler, maildir_new, recursive=False)

    print(f"Monitoring {maildir_new} for new emails...")

    observer.start()
    observer.join()
