// create an enumeration type for user roles
export enum UserRoles {
    Maintenance='maintenance',
    Manager='manager',
    Tenant='tenant',
    Owner='owner',
    Admin='admin'
}

export interface User {
    id:string,
    firstName: string,
    lastName: string,
    userName: string,
    email: string,
    contactNumber: number,
    password: string,
    role: UserRoles,
    isDeleted?: number  //optional property
}