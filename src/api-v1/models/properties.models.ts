export interface Property{
	id:string,
	ownerId:string,
	name:string,
	propertyType:string,
	details: {
		description:string,
		floors:number,
		rooms:number,
		accessories:{
			wifi:string,
			pool:string,
			parking:string
		}
	},
	location:{
		addressLine:string,
		postalAddress:string,
		town:string,
		country:string		
	}
	status:string,
	createdAt:string,
	isDeleted?:number	//optional property
}
