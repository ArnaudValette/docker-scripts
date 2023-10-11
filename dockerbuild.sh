#! /bin/sh
usage="
Usage: $0 <flag> [value] ...

    Available flags:

          Mandatory:
          -n   <name> (format: hyphen separated string)

          Optionnal:
          -x    When used, doesn't run the docker image after build.
          -p    <port> (format: host-port:docker-port )

"

if [ "$#" -lt 2 ];then
    echo "$usage"
    exit 1
fi

port="3000:3000"
name=""
build_only=false

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -p)
            if [[ "$2" =~ ^[0-9]{4}:[0-9]{4}$ ]]; then
                port="$2"
            else
                echo "Invalid port format. Expected format: 0000:0000"
                exit 1
            fi
            shift
            ;;
        -n)
            name="$2"
            shift
            ;;
        -x)
            build_only=true
        *)
            echo "Unknown option: $1"
            echo "$usage"
            exit 1
            ;;
    esac
    shift
done

if [ -z "$name" ]; then
    echo "-n option must be provided with a name argument."
    echo "$usage"
    exit 1
fi


if [ build_only ]; then
    docker build -t $name .
    exit 0
else
    docker build -t $name . && docker run -p $port $name
    exit 0
fi

