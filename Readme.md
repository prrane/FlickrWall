**An Infinity Scroll Image Wall using Flickr API**

- Using `flickr.photos.search` API
- It uses low quality square image 150x150, refer `Size Suffixes` [here](https://www.flickr.com/services/api/misc.urls.html)
- Cells per row can be controlled by `ImageCollectionView.Constants.maxCellsPerRow`
- A simple search feature is provided to search more photos, it defaults to `Cat` pictures :-)
- OperationQueue for newtork activities 
- KVO for synchronizing beteween network -> model -> view
- A simple cache (in the form of Dictionary) is used; it can be easily swapped to PINCache or others
