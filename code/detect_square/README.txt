README

Detect Square works by running adaptivethreshold(), findsquare() and rectify()

adaptivethreshold takes an image taken under bad lighting conditions and turns it into a black white image. The threshold is set adaptively based on the current local window condition. This way we can get a uniform black white picture even if the lightning is different.

findsquare works by detecting the largest boundingbox in the image. We assume that that box is the sudoku square. This will largely work but lead to incorrect results when there is a larger square, for example in 9.jpg. There is also some preprocessing done.

rectify works by finding the 4 corners of the sudoku square and then transforming them to a rectangle. I’m finding the corners by moving the corner inward until I hit black pixels.  After transforming I’m also cropping the image based on the original sudoku square size and the position of the corner points.