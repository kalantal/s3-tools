# s3-tools

### Requires
[s3cmd](https://github.com/kalantal/s3cmd) is required to move the objects.

  s3-pingtest.sh
> This script queries each s3 accessor to evaluate response times.
> You should run this from a device where the application you are testing for will reside.

Usage: 
```sh
$ ./s3-pingtest.sh
```

s3-speedtest.sh
> This script will generate files of varius sizes and upload them via S3 to Cleversafe to test speed.
> These tests will take place from the Cleversafe Host that your ~/.s3cfg is configured to.

File Sizes used:
  - 1MB
  - 5MB
  - 15MB
  - 50MB
  - 100MB
  - 50MB & 100MB files are done with and without Multi-Part-Upload

Usage: 
```sh
./s3-speedtest.sh
```
