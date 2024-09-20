# grafana-silence-creator

This script creates a silence in a Grafana instance using specified parameters.

## Usage

```shell
./silence.sh [-S start] -n name -v value -u url -b bearer [-c] [-e end] [-d days] [-h hours] [-m minutes] [-s seconds]
```

## Parameters

- `-S`: Start time (required if `-c` is not used)
- `-n`: Name of the label (required)
- `-v`: Value the label will match (required)
- `-u`: URL of the Grafana instance (required)
- `-b`: Bearer token (required)
- `-c`: Use current date for start time (required if `-S` is not used)
- `-e`: End time (optional, cannot be used with `-d`, `-h`, `-m`, or `-s`)
- `-d`: Number of days from start time for end time (optional, cannot be used with `-e`)
- `-h`: Number of hours from start time for end time (optional, cannot be used with `-e`)
- `-m`: Number of minutes from start time for end time (optional, cannot be used with `-e`)
- `-s`: Number of seconds from start time for end time (optional, cannot be used with `-e`)

### Notes

- You must specify either `-S` or `-c` for the start time.
- You must specify at least one of `-e`, `-d`, `-h`, `-m`, or `-s` for the end time.
- The `-d`, `-h`, `-m`, and `-s` flags will be added together to calculate the end time.

### Examples

#### Example 1: Using the current date for the start time and specifying the end time directly

Using the current date for the start time and specifying the end time directly.

```shell
./silence.sh -c -e "September 6, 2025 3:16PM" -n grafana_folder -v Prod8 -u vfl-061.engage.sas.com -b token
```

#### Example 2: Specifying the start time and using days, hours, minutes, and seconds to calculate the end time

Specifying the start time and using days, hours, minutes, and seconds to calculate the end time.

```shell
./silence.sh -S "September 6, 2024 3:16PM" -n grafana_folder -v Prod8 -u vfl-061.engage.sas.com -b token -d 1 -h 2 -m 30 -s 45
```

#### Example 3: Using the current date for the start time and specifying days and hours to calculate the end time

Using the current date for the start time and specifying days and hours to calculate the end time.

```shell
./silence.sh -c -n grafana_folder -v Prod8 -u vfl-061.engage.sas.com -b token -d 1 -h 2
```

#### Example 4: Specifying the start time and the end time directly

Specifying the start time and the end time directly.

```shell
./silence.sh -S "September 6, 2024 3:16PM" -e "September 6, 2025 3:16PM" -n grafana_folder -v Prod8 -u vfl-061.engage.sas.com -b token
```

#### Example 5: Using the current date for the start time and specifying minutes and seconds to calculate the end time

Using the current date for the start time and specifying minutes and seconds to calculate the end time.

```shell
./silence.sh -c -n grafana_folder -v Prod8 -u vfl-061.engage.sas.com -b token -m 30 -s 45
```



