# functions from shinyBS that we need but aren't exported
# copied from source code on 2024-01-13
# still doesn't get everything?

buildTooltipOrPopoverOptionsList <- function (title, placement, trigger, options, content) 
{
    if (is.null(options)) {
        options = list()
    }
    if (!missing(content)) {
        if (is.null(options$content)) {
            options$content = shiny::HTML(content)
        }
    }
    if (is.null(options$placement)) {
        options$placement = placement
    }
    if (is.null(options$trigger)) {
        if (length(trigger) > 1) 
            trigger = paste(trigger, collapse = " ")
        options$trigger = trigger
    }
    if (is.null(options$title)) {
        options$title = title
    }
    return(options)
}


createTooltipOrPopoverOnUI <- function (id, type, options) 
{
    options = paste0("{'", paste(names(options), options, sep = "': '", 
        collapse = "', '"), "'}")
    bsTag <- shiny::tags$script(shiny::HTML(paste0("$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('", 
        id, "', '", type, "', ", options, ")}, 500)});")))
    htmltools::attachDependencies(bsTag, shinyBSDep)
}


addTooltip <- function (session, id, title, placement = "bottom", trigger = "hover", 
    options = NULL) 
{
    options <- buildTooltipOrPopoverOptionsList(title, placement, 
        trigger, options)
    createTooltipOrPopoverOnServer(session, id, "tooltip", options)
}

createTooltipOrPopoverOnServer <- function (session, id, type, options) 
{
    data <- list(action = "add", type = type, id = id, options = options)
    session$sendCustomMessage(type = "updateTooltipOrPopover", 
        data)
}


shinyBSDep <- htmltools::htmlDependency("shinyBS", packageVersion("shinyBS"), src = c("href" = "sbs"), script = "shinyBS.js", stylesheet = "shinyBS.css")