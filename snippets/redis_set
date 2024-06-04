err := config.RedisConnectionPool.Set(ctx, key, value, expirationDuration).Err()
if err != nil {
    return fmt.Errorf("error, when attempting to set redis key: %s. Error: %v", key, err)
}
