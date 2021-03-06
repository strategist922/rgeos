\name{gUnion}
\alias{gUnion}
\alias{gUnaryUnion}
\alias{gUnionCascaded}
\alias{RGEOSUnionCascaded}
\alias{gLineMerge}
\alias{RGEOSLineMerge}

\title{Geometry Union}
\description{Functions for joining intersecting geometries.}
\usage{
gUnion(spgeom1, spgeom2, byid=FALSE, id=NULL)
gUnionCascaded(spgeom, id = NULL)
gUnaryUnion(spgeom, id = NULL)
gLineMerge(spgeom, byid=FALSE, id = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{spgeom1, spgeom2}{sp objects as defined in package sp}
  \item{byid}{Logical vector determining if the function should be applied across ids (TRUE) or the entire object (FALSE) for spgeom1 and spgeom2}
  \item{id}{Character vector defining id labels for the resulting geometries, if unspecified returned geometries will be labeled based on their parent geometries' labels; it may contain NA values for input objects not included in the union; it should define the memberships of the output Polygons objects}
  \item{spgeom}{sp Polygon(s) or Line(s) depending on the function used}
}

\details{Returns an sp object with intersecting geometries merged. If geometries do not intersect then both are returned as distinct subgeometries.

gUnionCascaded expects a single sp object of class SpatialPolygons with subgeometries which it unions together. gUnionCascaded can only dissolve MultiPolygon objects, so GeometryCollection objects to be dissolved, here a SpatialPolygons object, must be flattened a Polygons object; if GEOS version 3.3.0 is available, use gUnaryUnion.

gUnaryUnion expects a single sp object of class SpatialPolygons with subgeometries which it unions together; introduced in GEOS version 3.3.0, and handles GeometryCollection objects. If the id argument is used, it should be a character vector defining the memberships of the output Polygons objects, equal in length to the length of the polygons slot of spgeom.

gLineMerge is similar to gUnionCascaded but is written to work with lines, specifically it joins line segments with intersecting end points. 
}

\author{Roger Bivand & Colin Rundel}

\seealso{
\code{\link{gDifference}}
\code{\link{gIntersection}}
\code{\link{gSymdifference}}
}

\examples{
library(maptools)
nc1 <- readShapePoly(system.file("shapes/sids.shp", package="maptools")[1],
 proj4string=CRS("+proj=longlat +datum=NAD27"))
lps <- coordinates(nc1)
ID <- cut(lps[,1], quantile(lps[,1]), include.lowest=TRUE)
if (version_GEOS0() < "3.3.0") {
   reg4 <- gUnionCascaded(nc1, ID)
} else {
   reg4 <- gUnaryUnion(nc1, ID)
}
row.names(reg4)
par(mfrow=c(2,1))
plot(nc1)
plot(reg4)

par(mfrow=c(1,1))
gt <- GridTopology(c(0.05,0.05), c(0.1,0.1), c(2,2))
set.seed(1)
xv <- rnorm(length(coordinates(gt)[,1]))
xvs <- ifelse(xv > 0.2,1,0)
grd <- SpatialGridDataFrame(gt, data.frame(xvs))
spix <- as(grd, "SpatialPixelsDataFrame")
spol <- as(spix, "SpatialPolygonsDataFrame")
image(grd, axes=TRUE)
if (version_GEOS0() < "3.3.0") {
  spol1 <- gUnionCascaded(spol, as.character(spol$xvs))
} else {
  spol1 <- gUnaryUnion(spol, as.character(spol$xvs))
}
plot(spol1, add=TRUE)

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{spatial,union}

