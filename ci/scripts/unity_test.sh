#!/bin/bash
# Script taken from https://github.com/zifro-playground/car-controller
# Copyright Zifro © 2019

# Set error flags
set -o nounset
set +o errexit
set -o pipefail

PROJECT=${1?Project path}
TEST_RESULTS_FOLDER=${2:-$PROJECT}
PLATFORMS="editmode\nplaymode"

passed=$((0))
failed=$((0))
inconclusive=$((0))
skipped=$((0))
total=$((0))

errors=""

function escapeJson {
    : ${1?}
    local val=${1//\\/\\\\} # \ 
    # val=${val//\//\\\/} # / 
    # val=${val//\'/\\\'} # ' (not strictly needed ?)
    val=${val//\"/\\\"} # " 
    val=${val//	/\\t} # \t (tab)
    # val=${val//^M/\\\r} # \r (carriage return)
    val="$(echo "$val" | tr -d '\r')" # \r (carrige return)
    val=${val//
/\\\n} # \n (newline)
    val=${val//^L/\\\f} # \f (form feed)
    val=${val//^H/\\\b} # \b (backspace)
    echo -n "$val"
}

while read platform
do
    echo
    echo ">>>>>> Executing Unity '$platform' tests"

    test_results_file=$TEST_RESULTS_FOLDER/test-results-$platform.xml
    echo "Results file: $test_results_file"
    echo

    ${UNITY_EXECUTABLE:-xvfb-run -as '-screen 0 640x480x24' /opt/Unity/Editor/Unity} \
        -projectPath $PROJECT \
        -runTests \
        -testPlatform $platform \
        -testResults $test_results_file \
        -buildTarget Linux \
        -batchmode \
        -logfile

    UNITY_EXIT_CODE=$?

    echo
    echo "<<<<<< Unity '$platform' execution complete"
    echo

    if [ $UNITY_EXIT_CODE -eq 0 ]; then
        echo "Run succeeded, no failures occurred";
    elif [ $UNITY_EXIT_CODE -eq 2 ]; then
        echo "Run succeeded, some tests failed";
    elif [ $UNITY_EXIT_CODE -eq 3 ]; then
        echo "Run failure (other failure)";
    else
        echo "Unexpected exit code $UNITY_EXIT_CODE";
        exit $UNITY_EXIT_CODE
    fi

    echo
    echo ">>>>>> Gathering '$platform' test results"
    echo

    regexTestsPassed='passed="([0-9]+)"'
    regexTestsFailed='failed="([0-9]+)"'
    regexTestsInconc='inconclusive="([0-9]+)"'
    regexTestsSkippe='skipped="([0-9]+)"'

    results="$(grep "<test-run" "$test_results_file")"

    old_passed=$((passed))
    [[ $results =~ $regexTestsPassed ]] && [[ "${BASH_REMATCH[1]}" ]] && ((passed+=BASH_REMATCH[1]))
    echo "Passed: $passed (+$((passed-old_passed)))"
    
    old_failed=$((failed))
    [[ $results =~ $regexTestsFailed ]] && [[ "${BASH_REMATCH[1]}" ]] && ((failed+=BASH_REMATCH[1]))
    echo "Failed: $failed (+$((failed-old_failed)))"

    old_inconclusive=$((inconclusive))
    [[ $results =~ $regexTestsInconc ]] && [[ "${BASH_REMATCH[1]}" ]] && ((inconclusive+=BASH_REMATCH[1]))
    echo "Inconclusive: $inconclusive (+$((inconclusive-old_inconclusive)))"
    
    old_skipped=$((skipped))
    [[ $results =~ $regexTestsSkippe ]] && [[ "${BASH_REMATCH[1]}" ]] && ((skipped+=BASH_REMATCH[1]))
    echo "Skipped: $skipped (+$((skipped-old_skipped)))"
    echo

    while read id
    do
        name="$(xmlstarlet sel -T -t -v "//test-case[@id=$id]/@name" -n $test_results_file)"
        message="$(xmlstarlet sel -T -t -v "//test-case[@id=$id]/failure/message/text()" -n $test_results_file)"
        # stacktrace="$(xmlstarlet sel -T -t -v "//test-case[@id=$id]/failure/stack-trace/text()" -n $test_results_file)"
        echo "Found failed test: $name$($'\n\t')$message"

        if [ "$errors" ]
        then
            errors="$errors\n> :small_red_triangle_down: \`$platform\` *Failed* $name"
        else
            errors="> :small_red_triangle_down: \`$platform\` *Failed* $name"
        fi
        errors="$errors\n> \`\`\`\n$(escapeJson "$message")\n\`\`\`"
    done < <(xmlstarlet sel -T -t -m //test-case[failure] -v @id -n $test_results_file)
    
    while read id
    do
        name="$(xmlstarlet sel -T -t -v "//test-case[@id=$id]/@name" -n $test_results_file)"
        message="$(xmlstarlet sel -T -t -v "//test-case[@id=$id]/reason/message/text()" -n $test_results_file)"
        echo "Found inconclusive test: $name$($'\n\t')$message"
        
        if [ "$errors" ]
        then
            errors="$errors\n> :small_orange_diamond: \`$platform\` *Inconclusive* $name"
        else
            errors="> :small_orange_diamond: \`$platform\` *Inconclusive* $name"
        fi
        errors="$errors\n> \`\`\`\n$(escapeJson "$message")\n\`\`\`"
    done < <(xmlstarlet sel -T -t -m "//test-case[@result='Inconclusive']" -v @id -n $test_results_file)

done < <(echo -e "$PLATFORMS")

((total=passed+failed+skipped+inconclusive))

echo
echo "<<<<<< Testing complete"
echo "Total passed: $passed"
echo "Total failed: $failed"
echo "Total inconclusive: $inconclusive"
echo "Total skipped: $skipped"
echo
echo "Total num of tests: $total"
echo
echo "Found errors:"
echo -e "$errors"
echo

echo "export TEST_PASSED=\$(($passed))" >> $BASH_ENV
echo "export TEST_FAILED=\$(($failed))" >> $BASH_ENV
echo "export TEST_INCONCLUSIVE=\$(($inconclusive))" >> $BASH_ENV
echo "export TEST_SKIPPED=\$(($skipped))" >> $BASH_ENV
echo "export TEST_TOTAL=\$(($total))" >> $BASH_ENV
echo -e "read -rd '' TEST_ERRORS <<'ERROR_STRINGS'\n$errors\nERROR_STRINGS\n" >> $BASH_ENV
echo "export TEST_ERRORS" >> $BASH_ENV

exitCode=$((failed+inconclusive))
exit $exitCode
