var phantom = require('phantom');
var fs = require('fs');

var payloadIndex = -1;
process.argv.forEach(function(val, index, array) {
  if (val == "-payload") payloadIndex = index + 1;
});
var payload = JSON.parse(fs.readFileSync(process.argv[payloadIndex]));

console.log("payload:", payload);

var url = payload['url'];
if (!url){
  console.error("No url specified");
  process.exit(1);
}

/*
 * Render page to .png image file
 */
var output = 'screenshot.png';

phantom.create(function(ph) {
  return ph.createPage(function(page) {
    page.viewportSize = { width: 800, height: 800 };
    return page.open(url, function(status) {
      if (status !== 'success') {
        console.error('Unable to load the address!');
      } else {
        page.render(output);
        console.log("page rendered to " + output);
      }
      ph.exit();
    });
  });
});