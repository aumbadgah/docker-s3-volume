# docker-s3-volume

## configuration

### AWS credentials

Define AWS credentials with environment variables, or check the other options for configuring the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html#config-settings-and-precedence).

```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
```

### <local> directory

Define local directory with environment variable `LOCAL`, or as an inline parameter `<local>`.

Local directory defaults to `/data`.

### <remote> directory

Define remote s3 directory with environment variable `REMOTE`, or as an inline parameter `<remote>`.

Required, doesn't have a default value.

Accepts s3 urls, like `s3://my-bucket/path`.

## commands

### s3 pull [options]<local> [<remote>]]

Sync from s3 to local directory.

#### s3 pull -d [<local> [<remote>]]

Sync from s3 to local directory with `--delete` flag. Removes local files if not found in source s3 bucket.

### s3 push [options]<local> [<remote>]]

Sync from local directory to s3.

#### s3 push -d [<local> [<remote>]]

Sync from local directory to s3 with `--delete` flag. Removes remote files if not found in source local directory.
