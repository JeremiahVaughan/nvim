_, err := _DATABASE_CONNECTION_POOL_.Exec(
    "INSERT INTO _SOME_TABLE_ (_SOME_COLUMN_, _SOME_COLUMN_) VALUES ($1, $2)",
    r._SOME_PROPERTY_,
    r._SOME_PROPERTY_,
)
if err != nil {
    return fmt.Errorf("error, when attempting to persist a request for a stress test: %v", err)
}

