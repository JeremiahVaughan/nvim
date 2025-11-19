func SmartRedirect(w http.ResponseWriter, r *http.Request, u string) {
	if r.Header.Get("HX-Request") == "true" { // was triggered from button press
		w.Header().Set("HX-Redirect", u)
	} else { //  was triggered from page refresh
		http.Redirect(w, r, u, http.StatusSeeOther)
	}
}
