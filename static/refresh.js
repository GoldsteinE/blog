(() => {
	let url = new URL(window.location.href);
	let params = new URLSearchParams(url.search);
	if (params.has('refresh')) {
		params.delete('refresh');
		url.search = params.toString();
		const state = window.history.state;
		window.history.pushState(state, document.title, url.toString());
		window.location.reload(true);
	}
})()
