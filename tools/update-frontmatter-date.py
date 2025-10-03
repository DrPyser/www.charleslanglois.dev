import frontmatter
import sys
import datetime

if __name__ == "__main__":
    filename = sys.argv[1]
    content = frontmatter.load(filename)
    new_date = datetime.datetime.now(tz=datetime.timezone(datetime.timedelta(hours=-5))).isoformat(sep="T")
    print(f"Updating date of file {filename} from {content['date'].isoformat()} to {new_date}", file=sys.stderr)
    content["date"] = new_date
    print(frontmatter.dumps(content))
