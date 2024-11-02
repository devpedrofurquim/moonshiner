'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "f393d3c16b631f36852323de8e583132",
"main.dart.js": "b2d9693b34e4bbd8163a25da11407b75",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin": "37b264306f8b56b0130c1338028a097b",
"assets/fonts/MaterialIcons-Regular.otf": "6f8baccf5de83cc9c86c1d34982d5e1e",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/assets/tiles/Moonshiner2.tsx": "e2a4c69e6517a5f8bda1a0ed285da522",
"assets/assets/tiles/Level-02.tmx": "4f4bfa6fd3801c220e91713267eca455",
"assets/assets/tiles/levelOne.png": "eb9798f21c6a89530ebd25b79069988e",
"assets/assets/tiles/Houses(16x16).tsx": "a1751e0ac7b4ce99fb8cef69d393f45f",
"assets/assets/tiles/moonshiner.tiled-project": "97165873765b29a5041f09e541be15d5",
"assets/assets/tiles/Moonshiner.tsx": "18e7148c0ed2a1c50a4414ddcea6501d",
"assets/assets/tiles/moonshiner.tiled-session": "5243846025c6510dd747cdce122457fe",
"assets/assets/tiles/Level-01.tmx": "b21cfe3c30ebf9df291d0573246ae0e4",
"assets/assets/images/background.png": "ba3c59d0b97a19ff8afa96f90b3e5a94",
"assets/assets/images/20%2520Enemies.png": "73730ecfde474d999a027b06288751b6",
"assets/assets/images/Terrain/Houses(16x16).png": "b6e0cdd2b0dfb6a02fd7cf2ca32073d4",
"assets/assets/images/Terrain/levelOne.png": "eb9798f21c6a89530ebd25b79069988e",
"assets/assets/images/Terrain/Terrain%2520(16x16)2.png": "3f8d9b3847268a08fc74d4be482ccb22",
"assets/assets/images/Terrain/Terrain%2520(16x16).png": "df891f02449c0565d51e2bf7823a0e38",
"assets/assets/images/levelOne.png": "eb9798f21c6a89530ebd25b79069988e",
"assets/assets/images/HUD/joystick.png": "e7f060a3926979b8d3237a3ed725ede5",
"assets/assets/images/HUD/knob.png": "31bcf941812d86a2d00a97f77ecb2146",
"assets/assets/images/HUD/button_clicked.png": "54cbe111c3d0123d30cbf756febb4853",
"assets/assets/images/HUD/button.png": "6c65cc17c2d70f98c7a69b6ec15638ef",
"assets/assets/images/levelOne.tsx": "b2534d1649c5a6c28f4284bd8297228e",
"assets/assets/images/Background/new_sky.png": "11451c8a1c296c4677f5d87aabf9d8fd",
"assets/assets/images/Background/Pink.png": "31b5e360eb9610c58138bb7cfdfb96a1",
"assets/assets/images/Background/Yellow.png": "c3f96416e21f366bc0c3635ce5b530d5",
"assets/assets/images/Background/clouds.png": "620be0de7a5122538480010bad7e960f",
"assets/assets/images/Background/Brown.png": "45c9c887fa73b0ade76974de63ab9157",
"assets/assets/images/Background/Gray.png": "087c26c099d0c8da4f3a350ca2ec86ed",
"assets/assets/images/Background/Purple.png": "f8cc6aa8fd738e6e4db8b6607b7e6c37",
"assets/assets/images/Background/Green.png": "e6eeace8a9d516f2e9768e5228e824fb",
"assets/assets/images/Background/Blue.png": "f86e07aab82505fc49710152f83cc385",
"assets/assets/images/Items/Checkpoints/Checkpoint/Checkpoint%2520(Flag%2520Out)%2520(64x64).png": "1293e6846269345f2b9c206879a88122",
"assets/assets/images/Items/Checkpoints/Checkpoint/Checkpoint%2520(No%2520Flag).png": "dbe0368b9f1fde4c535ed0dac404ece2",
"assets/assets/images/Items/Checkpoints/Checkpoint/Checkpoint%2520(Flag%2520Idle)(64x64).png": "dd8752c20a0f69ab173f1ead16044462",
"assets/assets/images/Items/Objects/Pineapple.png": "0740bf84a38504383c80103d60582217",
"assets/assets/images/Items/Objects/Orange.png": "60e0f68620c442b9403a477bbe3588ed",
"assets/assets/images/Items/Objects/Gun.png": "17ea0177b21b964812cb2bbb94174517",
"assets/assets/images/Items/Objects/Lamp.png": "8df7b2c36ae2a6ea605b6dffc4a37ca6",
"assets/assets/images/Items/Objects/Kiwi.png": "3d903dd9bf3421c31a5373b0920c876e",
"assets/assets/images/Items/Objects/Collected.png": "0aa8cdedde5af58d5222c2db1e0a96de",
"assets/assets/images/Items/Objects/Melon.png": "eb6f978fbf95d76587bcf656c649540b",
"assets/assets/images/Items/Objects/Paper.png": "e356d35370da0c2ecc89f3c7bcb34aba",
"assets/assets/images/Items/Objects/Strawberry.png": "568a3f91b8f6102f1b518c1aba0e8e09",
"assets/assets/images/Main%2520Characters/Guy/Run%2520(32x32).png": "5f8dd2ff4c0590b9a6990a04e506c243",
"assets/assets/images/Main%2520Characters/Guy/Idle%2520(32x32).png": "a6b655b59d5855d4ce545914d40f254d",
"assets/assets/images/Main%2520Characters/Mask%2520Dude/Run%2520(32x32).png": "135879d965238d36f2efe3995c8bacd5",
"assets/assets/images/Main%2520Characters/Mask%2520Dude/Run%2520(32x32).xcf": "f063d52242b3469a0e5e17c40c969be5",
"assets/assets/images/Main%2520Characters/Mask%2520Dude/Fall%2520(32x32).png": "469d2d7814fa8258325eb5d305808315",
"assets/assets/images/Main%2520Characters/Mask%2520Dude/Hit%2520(32x32).png": "d03a7bbce7fbda59dd057397f86a8899",
"assets/assets/images/Main%2520Characters/Mask%2520Dude/Jump%2520(32x32).png": "99da59b514370539951a76ba1fe51821",
"assets/assets/images/Main%2520Characters/Mask%2520Dude/Wall%2520Jump%2520(32x32).png": "552254b40eac6d10d2c3d779edb92116",
"assets/assets/images/Main%2520Characters/Mask%2520Dude/Idle%2520(32x32).png": "932101fe42980571657384c01d601d52",
"assets/assets/images/Main%2520Characters/Mask%2520Dude/Double%2520Jump%2520(32x32).png": "5afb26aa4240eff1eab105eb3263ab83",
"assets/assets/images/Main%2520Characters/Virtual%2520Guy/Run%2520(32x32).png": "016f388a07f71a930fd79a7a806d5da8",
"assets/assets/images/Main%2520Characters/Virtual%2520Guy/Fall%2520(32x32).png": "5eb8c32845fad5fcc7794247eb91aed0",
"assets/assets/images/Main%2520Characters/Virtual%2520Guy/Hit%2520(32x32).png": "bbd39134a77e658b0b9b64ded537972c",
"assets/assets/images/Main%2520Characters/Virtual%2520Guy/Jump%2520(32x32).png": "f28e95fc98b251913baf3a21d5602381",
"assets/assets/images/Main%2520Characters/Virtual%2520Guy/Wall%2520Jump%2520(32x32).png": "76cbdd4a22d50bd65ac02be8a5eb1547",
"assets/assets/images/Main%2520Characters/Virtual%2520Guy/Idle%2520(32x32).png": "1cb575929ac10fe13dfafa61d78ba28d",
"assets/assets/images/Main%2520Characters/Virtual%2520Guy/Double%2520Jump%2520(32x32).png": "612926916a3e8c5deff2023722c465ac",
"assets/assets/images/Main%2520Characters/Journal%2520Guy/Run%2520(32x32).png": "f8acfc04808eef04c0a6a0a2a96de56a",
"assets/assets/images/Main%2520Characters/Journal%2520Guy/Fall%2520(32x32).png": "ef8f3627041b7ae2a1dc76dfc3e419f3",
"assets/assets/images/Main%2520Characters/Journal%2520Guy/Hit%2520(32x32).png": "4c1ba2bf4e576409abbbd1aacc91d51d",
"assets/assets/images/Main%2520Characters/Journal%2520Guy/Jump%2520(32x32).png": "4f048ccbc783c8eb3824be9651da8a34",
"assets/assets/images/Main%2520Characters/Journal%2520Guy/Wall%2520Jump%2520(32x32).png": "37ec0be0f82c3750a07efa558c032ee7",
"assets/assets/images/Main%2520Characters/Journal%2520Guy/Idle%2520(32x32).png": "deee5628582a902fc2892f9949d1244b",
"assets/assets/images/Main%2520Characters/Journal%2520Guy/Double%2520Jump%2520(32x32).png": "351c1df6eb5ac94209e8e490ab816879",
"assets/assets/images/Hello.png": "a55305158db44491131714a2496e6054",
"assets/assets/audio/collect_item.wav": "fad4263978f30b91c57c472fee79050c",
"assets/assets/audio/main_menu_music.mp3": "c9c49d2bd40f02f5546f254c71dbdc40",
"assets/assets/audio/the_farewell_ost.wav": "6f908e252bbdfd05ad8ad25f02e0a52d",
"assets/assets/audio/moonshine_ost.mp3": "070cd0bb0254b400a2d84803a11e0dc6",
"assets/assets/audio/in_the_dark_ost.mp3": "a61f0698593c608bfc4055ca9016874d",
"assets/NOTICES": "5ae56976761f94238259ea29d4d1c2bd",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "f2a3ecdf6fc210620123cf6c2086da29",
"assets/AssetManifest.bin.json": "7c73b0346ea6dfec1f6986a5f043e9de",
"index.html": "cff5ef10032b4d1484e07cc24ff94732",
"/": "cff5ef10032b4d1484e07cc24ff94732",
"manifest.json": "be6d3d3454b9a24cb5864f8d72bd4722",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"version.json": "2e54eb41fb9cbdf3d64f8aebd3b92b89",
"flutter_bootstrap.js": "a69e1d95f945b2b6bd517f0f31e82dd0"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
