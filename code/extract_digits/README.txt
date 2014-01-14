Extract digits works by scanning through the sudoku square with a window approximately the size of one digit field. The main challenge lies in removing the border lines of the window. We achieve a clean extracted digit in 2 steps.

First we shrink the window to an inner rectangle by looking for the largest bounding box inside the window and crop the window down to that size. The function for that is get_rectangle().

We have a second step to clean up any possible remaining black border pixels. shrink_rectangle() accomplishes this by shrinking all 4 edges of the rectangle until the middle 1/3 strip doesn’t contain any black pixels. (Most of the time this works, unless the grid line goes through the middle of the image without touching the border.)

Then we need to determine if the rectangle contains a digit inside. We achieve this by calculating the ratio of black pixels to the whole rectangle area size. For higher accuracy, we divide the window into a 3 x 3 grid and we weigh the center region of the window more.