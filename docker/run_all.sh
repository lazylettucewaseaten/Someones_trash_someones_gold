#!/bin/bash
set -e

BASE_DIR="assignments"
FINAL_RESULT="final_result.csv"
TIMEOUT=2


echo "rollno,assignment,question,verdict" > "$FINAL_RESULT"

normalize() {
    sed -e 's/[[:space:]]\+$//' -e '/^$/d' "$1" > "$1.normalized"
}

compare_outputs() {
    normalize "$1"
    normalize "$2"
    if diff -q --strip-trailing-cr --ignore-trailing-space "$1.normalized" "$2.normalized" > /dev/null; then
        echo "Accepted"
    else
        echo "Wrong Answer"
    fi
    rm -f "$1.normalized" "$2.normalized"
}

run_file() {
    local file="$1"
    local input="$2"
    local output="$3"
    local ext="${file##*.}"
    local verdict=""

    if [[ "$ext" == "cpp" ]]; then
        g++ "$file" -o code_exe || return 1
        timeout $TIMEOUT ./code_exe < "$input" > actual_output.txt
    elif [[ "$ext" == "py" ]]; then
        timeout $TIMEOUT python3 "$file" < "$input" > actual_output.txt
    elif [[ "$ext" == "java" ]]; then
        classname=$(basename "$file" .java)
        javac "$file" || return 1
        timeout $TIMEOUT java "$classname" < "$input" > actual_output.txt
        rm -f "$classname.class"
    else
        return 1
    fi

    compare_outputs actual_output.txt "$output"
}

# Traverse all assignment/question folders
find "$BASE_DIR" -type d -name submissions | while read submissions_dir; do
    question_dir=$(dirname "$submissions_dir")
    input_file="$question_dir/input.txt"
    output_file="$question_dir/output.txt"
    assignment_id=$(echo "$question_dir" | cut -d'/' -f2)
    question_id=$(echo "$question_dir" | cut -d'/' -f3)

    for file in "$submissions_dir"/*; do
        filename=$(basename "$file")
        rollno=$(echo "$filename" | cut -d'_' -f1)

        verdict=""
        if run_file "$file" "$input_file" "$output_file"; then
            verdict=$(compare_outputs actual_output.txt "$output_file")
        else
            verdict="Compilation/Error"
        fi

        echo "$rollno,$assignment_id,$question_id,$verdict" >> "final_result_${assignment_id}.csv"
        rm -f actual_output.txt code_exe 2>/dev/null || true
    done
done

