// Version: 2026-07-24
// Description: Converts Gregorian input (DD/MM/YY or DD/MM/YYYY) into Ethiopian calendar dates.

const ETHIOPIAN_MONTHS = [
    "መስከረም", "ጥቅምት", "ሕዳር", "ታህሳስ", "ጥር", "የካቲት", "መጋቢት",
    "ሚያዝያ", "ግንቦት", "ሰኔ", "ሐምሌ", "ነሐሴ", "ጳጉሜ",
];

const GREGORIAN_MONTHS_EN = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
];

const GREGORIAN_MONTHS_AM = [
    "ጃንዋሪ", "ፌብሩዋሪ", "ማርች", "ኤፕሪል", "ሜይ", "ጁን",
    "ጁላይ", "ኦገስት", "ሴፕቴምበር", "ኦክቶበር", "ኖቬምበር", "ዲሴምበር"
];

// Days per Gregorian month (index 0 = January), non-leap-year values
const DAYS_IN_MONTH = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

// Cumulative day offsets for each of the 4 years in an Ethiopian leap cycle
const ETHIOPIAN_YEAR_STARTS = [0, 365, 730, 1096];

// Returns true if a Gregorian year is a leap year
fn is_gregorian_leap_year(year) {
    if year % 400 == 0 { return true; }
    if year % 100 == 0 { return false; }
    return year % 4 == 0;
}

// Determines the maximum valid days for a given Gregorian month & year
fn get_max_gregorian_days(month, year) {
    if month == 2 && is_gregorian_leap_year(year) {
        return 29;
    }
    return global::DAYS_IN_MONTH[month - 1];
}

// Converts Gregorian date to Julian Day Number (JDN)
fn gregorian_to_jdn(gyear, gmonth, gday) {
    let a = (14 - gmonth) / 12;
    let y = gyear + 4800 - a;
    let m = gmonth + 12 * a - 3;
    return gday + ((153 * m + 2) / 5) + (365 * y) + (y / 4) - (y / 100) + (y / 400) - 32045;
}

// Converts Julian Day Number (JDN) to Ethiopian date [day, month, year]
fn jdn_to_ethiopian(jdn) {
    let r = jdn - 1724221;
    let n = r / 1461;
    let rem = r % 1461;

    // Find which year of the 4-year cycle `rem` falls into
    let y_cycle = 3;
    for i in 0..3 {
        if rem < global::ETHIOPIAN_YEAR_STARTS[i + 1] {
            y_cycle = i;
            break;
        }
    }
    let day_in_year = rem - global::ETHIOPIAN_YEAR_STARTS[y_cycle];

    let eyear = 4 * n + y_cycle + 1;
    let emonth = (day_in_year / 30) + 1;
    let eday = (day_in_year % 30) + 1;

    return [eday, emonth, eyear];
}

// Splits input on the first separator found among '/', '.', '-'
fn split_date(input) {
    for sep in ["/", ".", "-"] {
        let data = input.split(sep);
        if data.len() == 3 {
            return data;
        }
    }
    return [];
}

// Parses input string into valid [day, month, year] or returns []
fn parse_date(input) {
    let data = split_date(input);
    if data.len() != 3 {
        return [];
    }

    let day = parse_int(data[0]);
    let month = parse_int(data[1]);
    let year = parse_int(data[2]);

    if day == () || month == () || year == () {
        return [];
    }

    // Expand 2-digit years (e.g., 26 -> 2026)
    if year >= 0 && year < 100 {
        year += 2000;
    }

    if month >= 1 && month <= 12 && year >= 1 && year <= 2100 {
        let max_days = get_max_gregorian_days(month, year);
        if day >= 1 && day <= max_days {
            return [day, month, year];
        }
    }

    return [];
}

// Zero-pads a number to at least 2 digits (for ISO date formatting)
fn pad2(n) {
    return if n < 10 { `0${n}` } else { `${n}` };
}

// Main IME / Text Translation Entrypoint
fn translate(input) {
    let commit = false;
    if input.ends_with("'") {
        input = input.sub_string(0, input.len() - 1);
        commit = true;
    }

    let greg_date = parse_date(input);
    if greg_date.is_empty() {
        return [];
    }

    let gday = greg_date[0];
    let gmonth = greg_date[1];
    let gyear = greg_date[2];

    // Compute Ethiopian equivalent date
    let jdn = gregorian_to_jdn(gyear, gmonth, gday);
    let eth_date = jdn_to_ethiopian(jdn);

    let eth_day = eth_date[0];
    let eth_month = global::ETHIOPIAN_MONTHS[eth_date[1] - 1];
    let eth_year = eth_date[2];

    let greg_month_en = global::GREGORIAN_MONTHS_EN[gmonth - 1];
    let greg_month_am = global::GREGORIAN_MONTHS_AM[gmonth - 1];

    [
        input,
        "",
        [
            // Candidate Outputs
            `${eth_day} ${eth_month} ${eth_year}`,                 // e.g., 17 ሐምሌ 2018
            `${eth_month} ${eth_day} ቀን ${eth_year} ዓ.ም.`,        // e.g., ሐምሌ 17 ቀን 2018 ዓ.ም.
            `${gday} ${greg_month_en} ${gyear}`,                    // e.g., 24 July 2026
            `${greg_month_am} ${gday}, ${gyear}`,                   // e.g., ጁላይ 24, 2026
            `${gyear}-${pad2(gmonth)}-${pad2(gday)}`                // e.g., 2026-07-24
        ],
        commit
    ]
}
