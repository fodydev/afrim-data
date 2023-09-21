const MONTHS = [
    "መስከረም", "ጥቅምት", "ሕዳር", "ታህሳስ", "ጥር", "የካቲት", "መጋቢት",
    "ሚያዝያ", "ግንቦት", "ሰኔ", "ሐምሌ", "ነሐሴ", "ጳጉሜ",
];

fn parse_date(input) {
    let data = input.split('/');
    
    if data.len() == 3 {
        let day = parse_int(data[0]);
        let month = parse_int(data[1]);
        let year = parse_int(data[2]);
        
        if day in 1..31 && month in 1..13 && year in 1..2100 {
            return [day, month, year];
        }
    }
    
    return [];
}

// Main function
fn translate(input) {
    let date = parse_date(input);
    
    if !date.is_empty() {
        return [input, "", [
            `${date[0]} ${global::MONTHS[date[1]]} ${date[2]}`,
            `${global::MONTHS[date[1]]} ${date[0]}, ${date[2]}`
        ], true];
    }
    
    return [input, "", "", false];
}
