/// The stages a screen goes through while it loads what it shows.
public enum ViewState<Content> {

    /// Nothing has been requested yet.
    case idle

    /// The content is being loaded.
    case loading

    /// Loading the content failed.
    case error

    /// The content has loaded.
    case loaded(Content)

}
