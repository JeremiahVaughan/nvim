
// log exact query used for debugging queries
func FormatQuery(query string, args ...interface{}) string {
	for _, arg := range args {
		var formatted string
		switch v := arg.(type) {
		case string:
			formatted = fmt.Sprintf("'%v'", v)
		case sql.NullString:
			if v.Valid {
				formatted = fmt.Sprintf("'%v'", v.String)
			} else {
				formatted = "NULL"
			}
		default:
			formatted = fmt.Sprintf("%v", v)
		}
		query = strings.Replace(query, "?", formatted, 1)
	}
	return base64.StdEncoding.EncodeToString([]byte(query))
}

// Example:
if err != nil {
    theStatement = shared.FormatQuery(theStatement, args...)
    return nil, fmt.Errorf("error, when attempting to retrieve records. Query: %s. Error: %v", theStatement, err)
}
