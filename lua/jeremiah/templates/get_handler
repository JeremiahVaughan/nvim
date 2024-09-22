import (
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
)

type _CAMEL_CASE_NAME_Request struct {
	Id string `json:"id"`
}

type _CAMEL_CASE_NAME_Response struct {
	Result string `json:"result"`
}


func validate_NAME_Request(req *_CAMEL_CASE_NAME_Request) error {
	var errorFeedback []error
	if len(req.Id) == 0 {
		errorFeedback = append(errorFeedback, errors.New("input string cannot be empty"))
	}
	if len(req.Id) > 255 {
		errorFeedback = append(errorFeedback, errors.New("input string cannot be more that 255 chars"))
	}
	if len(errorFeedback) > 0 {
		return fmt.Errorf("errors, when validating request: %v", errorFeedback)
	}
	return nil
}

func handle_NAME_(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "error, only GET method is supported", http.StatusMethodNotAllowed)
		return
	}

	id := r.URL.Query().Get("id")
	req := _CAMEL_CASE_NAME_Request{Id: id}


	err := validate_NAME_Request(&req)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	result, err := _CAMEL_CASE_NAME_(req.Id)
	if err != nil {
		http.Error(w, fmt.Sprintf("error, failed to perform _CAMEL_CASE_NAME_ handler action: %v", err), http.StatusInternalServerError)
	    return
	}
	res := _CAMEL_CASE_NAME_Response{Result: result}
	responseData, err := json.Marshal(res)
	if err != nil {
		http.Error(w, "error, failed to create JSON response", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	_, err = w.Write(responseData)
	if err != nil {
		http.Error(w, "error, failed to write response", http.StatusInternalServerError)
		return
	}
}

func _CAMEL_CASE_NAME_(s string) (string, error) {
	// todo implement something
	return "id#123", nil
}

