result, err := config.RedisConnectionPool.Get(ctx, key).Result()
if err != nil {
    if errors.Is(err, redis.Nil) {
        return nil, nil
    }
    return nil, fmt.Errorf("error, when attempting to get key %s from redis. Error %v", key, err)
}
