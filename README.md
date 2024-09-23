# grafana-silence-creator

This script creates a silence in a Grafana instance using specified parameters.

## Usage

```shell
./silence.sh [-a start] -n name -v value -u url -b bearer [-c] [-e end] [-d days] [-h hours] [-m minutes] [-a seconds]
```

## Parameters

- `-a`: Start time in UTC time (required if `-c` is not used)
- `-n`: Name of the label (required)
- `-v`: Value the label will match (required)
- `-u`: URL of the Grafana instance (required) 
- `-b`: Bearer token (required)
- `-c`: Use current date for start time (required if `-a` is not used)
- `-e`: End time in UTC time (optional, cannot be used with `-d`, `-h`, `-m`, or `-a`)
- `-d`: Number of days from start time for end time (optional, cannot be used with `-e`)
- `-h`: Number of hours from start time for end time (optional, cannot be used with `-e`)
- `-m`: Number of minutes from start time for end time (optional, cannot be used with `-e`)
- `-a`: Number of seconds from start time for end time (optional, cannot be used with `-e`)

### Notes

- You must specify either `-a` or `-c` for the start time.
- You must specify at least one of `-e`, `-d`, `-h`, `-m`, or `-a` for the end time.
- The `-d`, `-h`, `-m`, and `-a` flags will be added together to calculate the end time.
- This script was tested with Grafana version 11.x. It may not work with earlier versions such as 8.x.

### Examples

#### Example 1: Using the current date for the start time and specifying the end time directly

Using the current date for the start time and specifying the end time directly.

```shell
./silence.sh -c -e "September 6, 2025 3:16PM" -n grafana_folder -v Prod8 -u example.com/grafana -b token
```

#### Example 2: Specifying the start time and using days, hours, minutes, and seconds to calculate the end time

Specifying the start time and using days, hours, minutes, and seconds to calculate the end time.

```shell
./silence.sh -a "September 6, 2024 3:16PM" -n grafana_folder -v Prod8 -u example.com/grafana -b token -d 1 -h 2 -m 30 -a 45
```

#### Example 3: Using the current date for the start time and specifying days and hours to calculate the end time

Using the current date for the start time and specifying days and hours to calculate the end time.

```shell
./silence.sh -c -n grafana_folder -v Prod8 -u example.com/grafana -b token -d 1 -h 2
```

#### Example 4: Specifying the start time and the end time directly

Specifying the start time and the end time directly.

```shell
./silence.sh -a "September 6, 2024 3:16PM" -e "September 6, 2025 3:16PM" -n grafana_folder -v Prod8 -u example.com/grafana -b token
```

#### Example 5: Using the current date for the start time and specifying minutes and seconds to calculate the end time

Using the current date for the start time and specifying minutes and seconds to calculate the end time.

```shell
./silence.sh -c -n grafana_folder -v Prod8 -u example.com/grafana -b token -m 30 -a 45
```



