
/*
    Delegate for the music download process
*/
public protocol MusicDownloadDelegate {

    func downloadComplete(error : Bool)

    func downloadProgress(progressText : String)
}

