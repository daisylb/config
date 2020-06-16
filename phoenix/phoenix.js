Phoenix.set({ openAtLogin: false });

console.log = (...args) => Phoenix.log(...args);

console.log('hi');

var delHandler = new Key('delete', [], (...a) => console.log(a));
delHandler.disable();

var evt = Event.on('appDidActivate', e => {
	if (e.bundleIdentifier() == 'com.apple.mail') delHandler.enable();
	else delHandler.disable();
});
