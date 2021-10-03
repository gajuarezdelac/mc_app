String makePlaceholders(int len) {
    String placeHolders = "?";
    for(var i = 1; i < len; i++) {
      placeHolders = placeHolders + ",?";
    }

    return placeHolders;
}