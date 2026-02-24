#!/usr/bin/env bash
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
exec java -jar "$HERE/gradle/wrapper/gradle-wrapper.jar" "$@"
