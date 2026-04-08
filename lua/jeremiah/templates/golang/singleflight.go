import (
	"context"
	"fmt"
	"sync"
	"time"

	"golang.org/x/sync/singleflight"
)

type User struct {
	ID   string
	Name string
}

type UserService struct {
	group singleflight.Group
	cache sync.Map
}

func (s *UserService) GetUser(ctx context.Context, userID string) (User, error) {
	if cached, ok := s.cache.Load(userID); ok {
		return cached.(User), nil
	}

	value, err, _ := s.group.Do(userID, func() (any, error) {
		// Double check once we're inside the singleflight call in case
		// another caller filled the cache while we were waiting.
		if cached, ok := s.cache.Load(userID); ok {
			return cached.(User), nil
		}

		user, err := fetchUserFromDB(ctx, userID)
		if err != nil {
			return nil, err
		}

		s.cache.Store(userID, user)
		return user, nil
	})
	if err != nil {
		return User{}, fmt.Errorf("get user %q: %w", userID, err)
	}

	return value.(User), nil
}

func (s *UserService) RefreshUser(ctx context.Context, userID string) (User, bool, error) {
	value, err, shared := s.group.Do(userID, func() (any, error) {
		user, err := fetchUserFromDB(ctx, userID)
		if err != nil {
			return nil, err
		}

		s.cache.Store(userID, user)
		return user, nil
	})
	if err != nil {
		return User{}, false, fmt.Errorf("refresh user %q: %w", userID, err)
	}

	return value.(User), shared, nil
}

func fetchUserFromDB(ctx context.Context, userID string) (User, error) {
	select {
	case <-ctx.Done():
		return User{}, ctx.Err()
	case <-time.After(250 * time.Millisecond):
		fmt.Printf("expensive fetch for user %s\n", userID)
		return User{ID: userID, Name: "Ada"}, nil
	}
}

func exampleSingleflight() {
	service := &UserService{}
	var wg sync.WaitGroup

	for range 5 {
		wg.Add(1)
		go func() {
			defer wg.Done()

			user, shared, err := service.RefreshUser(context.Background(), "user-123")
			if err != nil {
				fmt.Println("error:", err)
				return
			}

			fmt.Printf("user=%+v shared=%t\n", user, shared)
		}()
	}

	wg.Wait()
}
