const { src, dest } = require('gulp');

function buildIcons() {
	return src('nodes/**/*.{png,svg}')
		.pipe(dest('dist/nodes'));
}

function buildCredentialsIcons() {
	return src('credentials/**/*.{png,svg}')
		.pipe(dest('dist/credentials'));
}

exports['build:icons'] = function(cb) {
	buildIcons();
	buildCredentialsIcons();
	cb();
};

exports.default = exports['build:icons'];
