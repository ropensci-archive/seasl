#' @title Caching
#'
#' @description Manage cached `seasl` files with \pkg{hoardr}
#'
#' @export
#' @name csl_cache
#'
#' @details The dafault cache directory is
#' `paste0(rappdirs::user_cache_dir(), "/R/seasl")`, but you can set
#' your own path using `cache_path_set()`
#'
#' `cache_delete` only accepts 1 file name, while
#' `cache_delete_all` doesn't accept any names, but deletes all files.
#' For deleting many specific files, use `cache_delete` in a [lapply()]
#' type call
#'
#' @section Useful user functions:
#' 
#' - `csl_cache$cache_path_get()` get cache path
#' - `csl_cache$cache_path_set()` set cache path
#' - `csl_cache$list()` returns a character vector of full
#'  path file names
#' - `csl_cache$files()` returns file objects with metadata
#' - `csl_cache$details()` returns files with details
#' - `csl_cache$delete()` delete specific files
#' - `csl_cache$delete_all()` delete all files, returns nothing
#'
#' @examples \dontrun{
#' csl_cache
#'
#' # list files in cache
#' csl_cache$list()
#'
#' # delete certain database files
#' # csl_cache$delete("file path")
#' # csl_cache$list()
#'
#' # delete all files in cache
#' # csl_cache$delete_all()
#' # csl_cache$list()
#'
#' # set a different cache path from the default
#' }
NULL
