import { Property } from '../models/properties.models'

export function propertyFilterQuery (queryObj: Property) {
    const filters: string[] = []
    const values: any = {}

    // name as a search parameter
    if (queryObj.name){
        filters.push("name = @name")
        values.name = queryObj.name
    }
    
    // propertyType
    if (queryObj.propertyType){
        filters.push("propertyType = @propertyType")
        values.propertyType = queryObj.propertyType
    }

    // detailsJson
    if (queryObj.details) {
        if (queryObj.details.description) {
            filters.push("JSON_VALUE(detailsJson, '$.description') LIKE @description")
            values.description = queryObj.details.description
        }
        if (queryObj.details.floors) {
            filters.push("JSON_VALUE(detailsJson,'$.floors') LIKE @floors")
            values.floors = queryObj.details.floors
        }
        if (queryObj.details.rooms) {
            filters.push("JSON_VALUE(detailsJson,'$.rooms') LIKE @rooms")
            values.rooms = queryObj.details.rooms
        }
        if (queryObj.details.accessories) {
            if (queryObj.details.accessories.wifi) {
                filters.push("JSON_VALUE(detailsJson,'$.accessories.wifi') LIKE @wifi")
                values.wifi = queryObj.details.accessories.wifi
            }
            if (queryObj.details.accessories.pool) {
                filters.push("JSON_VALUE(detailsJson,'$.accessories.pool') LIKE @pool")
                values.pool = queryObj.details.accessories.pool
            }
            if (queryObj.details.accessories.parking) {
                filters.push("JSON_VALUE(detailsJson,'$.accessories.parking') LIKE @parking")
                values.parking = queryObj.details.accessories.parking
            }
        }
    }

    // locationJson
    if(queryObj.location){
        // too much loading time. work on them individual to icrease speed
        // Object.keys(queryObj.location).forEach((key) => {
        //     filters.push(`JSON_VALUE(locationJson,'$.${key}', NVARCHAR(MAX)) LIKE @${key}`)
        //     values[key] = queryObj.location[key]
        // }) 
        if (queryObj.location.addressLine) {
            filters.push("JSON_VALUE(locationJson,'$.addressLine') LIKE @addressLine")
            values.addressLine = queryObj.location.addressLine
        }
        if (queryObj.location.postalAddress) {
            filters.push("JSON_VALUE(locationJson,'$.postalAddress') LIKE @postalAddress")
            values.postalAddress = queryObj.location.postalAddress
        }
        if (queryObj.location.town) {
            filters.push("JSON_VALUE(locationJson,'$.town') LIKE @town")
            values.town = queryObj.location.town
        }
        if (queryObj.location.country) {
            filters.push("JSON_VALUE(locationJson,'$.country') LIKE @country")
            values.country = queryObj.location.country
        }
    }

    // status
    if(queryObj.status){
        filters.push("status = @status")
        values.status = queryObj.status
    }
    
    return { filters: filters.join(" AND "), values }
}
