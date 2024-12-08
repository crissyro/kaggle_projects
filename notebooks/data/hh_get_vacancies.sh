#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 \"job_name\""
    exit 1
fi

JOB_NAME="$1"

ENCODED_JOB_NAME=$(echo -n "$JOB_NAME" | iconv -t utf8 | jq -s -R -r @uri)

PER_PAGE=100

FIRST_PAGE=$(curl -s "https://api.hh.ru/vacancies?text=$ENCODED_JOB_NAME&per_page=$PER_PAGE&page=0")
FOUND=$(echo "$FIRST_PAGE" | jq '.found')
if [ "$FOUND" == "null" ]; then
    echo "No vacancies found."
    exit 0
fi

TOTAL_PAGES=$(( (FOUND + PER_PAGE - 1) / PER_PAGE ))

echo "Total vacancies found: $FOUND"
echo "Total pages to fetch: $TOTAL_PAGES"

for (( PAGE=0; PAGE<TOTAL_PAGES; PAGE++ )); do
    curl -s "https://api.hh.ru/vacancies?text=$ENCODED_JOB_NAME&per_page=$PER_PAGE&page=$PAGE" | jq -c '.items[]'
    sleep 2
done | jq -s '.' > hh_vacancies.json