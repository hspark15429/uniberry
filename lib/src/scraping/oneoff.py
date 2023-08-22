import json

def process_period(period):
    parts = period.split('-')
    if len(parts) == 2:
        days, times = parts[0], parts[1]
        start_time, end_time = times.split()
        return [f"{days}{time}" for time in range(int(start_time), int(end_time) + 1)]
    else:
        return [period]

# Read data from courses.json
with open("courses.json", "r", encoding="utf-8") as file:
    data = json.load(file)

updated_data = []

# Process and update the periods
for entry in data:
    updated_periods = []
    for period in entry["periods"]:
        updated_periods.extend(process_period(period))
    entry["periods"] = updated_periods
    updated_data.append(entry)

# Write updated data back to courses.json
with open("courses2.json", "w", encoding="utf-8") as file:
    json.dump(updated_data, file, indent=4, ensure_ascii=False)
