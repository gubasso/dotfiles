function __parse_version_spec --description 'Parse version specifier and return the target version'
    # Handles common version specifier formats:
    #   ">=3.11"        → 3.11 (minimum)
    #   ">=3.11,<3.13"  → 3.12 (latest in range)
    #   "^3.11"         → 3.11 (caret = compatible)
    #   "~3.11"         → 3.11 (tilde = approximate)
    #   "==3.11"        → 3.11 (exact)
    #   "3.11"          → 3.11 (bare version)
    #
    # For ranges with upper bound (<X.Y), returns X.(Y-1) as the target

    set -l spec $argv[1]
    if test -z "$spec"
        return 1
    end

    # Check for upper bound first: <X.Y or <=X.Y
    set -l upper_match (string match -r '<\s*=?\s*(\d+)\.(\d+)' -- "$spec")
    if test -n "$upper_match"
        set -l major $upper_match[2]
        set -l minor $upper_match[3]

        # If it's strictly less than (<), use minor - 1
        if string match -q '*<=*' -- "$spec"
            # <=3.13 means 3.13 is allowed
            echo "$major.$minor"
        else
            # <3.13 means use 3.12
            if test $minor -gt 0
                set minor (math $minor - 1)
                echo "$major.$minor"
            else
                # <4.0 case: can't decrement minor, fall back to lower bound
                set -l lower_match (string match -r '>=?\s*(\d+)\.(\d+)' -- "$spec")
                if test -n "$lower_match"
                    echo "$lower_match[2].$lower_match[3]"
                else
                    # No lower bound found - return empty
                    return 1
                end
            end
        end
        return 0
    end

    # No upper bound - extract any version number present
    set -l version_match (string match -r '(\d+\.\d+)' -- "$spec")
    if test -n "$version_match"
        echo $version_match[2]
        return 0
    end

    # No version found
    return 1
end
