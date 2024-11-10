import { Router } from 'express'
import { addProperty } from '../controllers/properties.controllers'

const propertyRouter = Router()

propertyRouter.post('/add/:id', addProperty)

export default propertyRouter