% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/stack.R
\name{stack_trim}
\alias{stack_trim}
\title{Trim top call layers from the evaluation stack}
\usage{
stack_trim(stack, n = 1)
}
\arguments{
\item{stack}{An evaluation stack.}

\item{n}{The number of call frames (not eval frames) to trim off
the top of the stack. In other words, the number of layers of
intervening frames to trim.}
}
\description{
\code{\link[=ctxt_stack]{ctxt_stack()}} can be tricky to use in real code because all
intervening frames are returned with the stack, including those at
\code{ctxt_stack()} own call site. \code{stack_trim()} makes it easy to
remove layers of intervening calls.
}
\section{Life cycle}{


These functions are in the questioning stage. We are no longer
convinced they belong in rlang as they are mostly for REPL
interaction and runtime inspection rather than function
development.
}

\examples{
# Intervening frames appear on the evaluation stack:
identity(identity(ctxt_stack()))

# stack_trim() will trim the first n layers of calls:
stack_trim(identity(identity(ctxt_stack())))

# Note that it also takes care of calls intervening at its own call
# site:
identity(identity(
  stack_trim(identity(identity(ctxt_stack())))
))

# It is especially useful when used within a function that needs to
# inspect the evaluation stack but should nonetheless be callable
# within nested calls without side effects:
stack_util <- function() {
  # n = 2 means that two layers of intervening calls should be
  # removed: The layer at ctxt_stack()'s call site (including the
  # stack_trim() call), and the layer at stack_util()'s call.
  stack <- stack_trim(ctxt_stack(), n = 2)
  stack
}
user_fn <- function() {
  # A user calls your stack utility with intervening frames:
  identity(identity(stack_util()))
}
# These intervening frames won't appear in the evaluation stack
identity(user_fn())
}
\keyword{internal}
