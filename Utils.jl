module Utils
using Dates
using HTTP

export get_example
export get_input

AOC_SESSION = "53616c7465645f5f9642b31e0ec86d21a719690050401803130ad3f218a99c33e869ccf708bafd11e2ed7c580a46c8d57b7f0643b764215d2ca031dc23d0ef2c"

current_year() =  year(now(UTC))
current_day() = day(now(UTC)) - ifelse((hour(now(UTC)) - 5) >= 0, 0, 1)

test_type(type, mat) = !any(any.([isnothing.(tryparse.(type,x)) for x in mat]))

parse_type(type, mat) = [parse.(type,x) for x in mat]

function check_days(aoc_year::Number, aoc_day::Number)
    if (aoc_year > current_year()) | 
        ((aoc_year == current_year()) & (aoc_day > current_day()))
        error("Advent of Code puzzle is not yet available for day $aoc_day of $(aoc_year)!")
    elseif aoc_year < 2015
        error("There are no Advent of Code puzzles from before 2015!")
    elseif aoc_day > 25
        error("There are only 25 days in the Advent of Code!")
    end
end

function query_aoc(url::AbstractString)
    res = HTTP.request(
        "GET",
        url,
        cookies = Dict("session" => AOC_SESSION)
    )
    if res.status != 200
        error("HTTP error code: $(res.status)")
    end
    body = String(res.body)
    return body
end

function parse_text(text::AbstractString, auto_parse::Bool)
    text = split.(String.(split(text,"\n", keepempty = false)),r"[ \t]+")
    parsed = false
    if auto_parse
        for type in [Int64, Float64]
            if test_type(type, text)
                final = parse_type(type, text)
                parsed = true
                break
            end
        end
    end
    if !auto_parse | !parsed
        final = [String.(x) for x in text]
    end
    # check if we've got unneeded vecs
    if length(final[1]) == 1
        final = [x[1] for x in final]
    end
    return final
end

function get_example(aoc_year::Number = current_year(),
                     aoc_day::Number = current_day(),
                     auto_parse::Bool = true;
                     which_example::Number = 0,
                     override::String = "")
    if length(override) != 0
        example = override
    else
        check_days(aoc_year, aoc_day)
        body = query_aoc("https://adventofcode.com/$aoc_year/day/$aoc_day")
        caps = match(r"(?<=<pre><code>)((.|\n)*?)(?=<\/code><\/pre>)",body).captures
        caps = [cap for cap in caps if length(cap) != 1] # filter odd regex match?
        if length(caps) == 2
            if (caps[1] != caps[2]) & ismissing(which_example)
                @warn "Multiple different examples found! Defaulting to the second example (to override, specify which_example as an arg)."
                example = caps[2]
            elseif which_example != 0
                example = caps[which_example]
            else
                example = caps[end]
            end
        elseif length(caps) > 2
            error("Parsing error detected! Please pass in the example manually using override.")
        else 
            example = caps[end]
        end
    end
    final = parse_text(example, auto_parse)
    return final
end

function get_input(aoc_year::Number = current_year(),
                   aoc_day::Number = current_day(),
                   auto_parse = true)
    check_days(aoc_year, aoc_day)
    body = query_aoc("https://adventofcode.com/$aoc_year/day/$aoc_day/input")
    final = parse_text(body, auto_parse)
    return final
end

end