### Did you know that iOS supports native jpeg2000 decoding?

… I didn't. 

### How

No need for Jasper, Openjpeg, or kakadu. This magic is done with nothing more than the [ImageIO framework ](https://developer.apple.com/library/ios/documentation/graphicsimaging/conceptual/ImageIOGuide/imageio_source/ikpg_source.html#//apple_ref/doc/uid/TP40005462-CH218-SW3).

Tested on simulator and iOS 7 device, on a 6k x 4k image.

Update: tested well on a 21k x 18k image on an iOS 5 device with no lag.

Much work to be done to see how large (100k x 100k) images are handled, but off to a promising start.

### Usage

clone repo, build and run.
