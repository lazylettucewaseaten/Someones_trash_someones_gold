const express=require('express')
const app=express()
const cors=require('cors')
require('dotenv').config()
app.use(express.json()); //dont forget ot add this in future
app.use(express.urlencoded({ extended: true })); //for form data 
app.use(cors())
const route=require('./routes/routes')
const connectDB=require('./database/connectdb')
app.get('/',(req,res)=>{
    res.send("Something is there")
})
app.use('/ashley',route)
const port=8000
const start =async () => {
    try {
        console.log('Trying')
        await connectDB(process.env.URI)
        app.listen(port,console.log('Server is on'))    
    } catch (error) {
        console.log(error)
    }
}
start()
