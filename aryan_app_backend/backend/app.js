const express=require('express')
const cors =require('cors')
const app=express()
require('dotenv').config()
app.use(express.json()); 
app.use(cors())
const route=require('./routes/routes')
const connectDB=require('./database/connectdb')
app.get('/',(req,res)=>{
    res.send("Something is there2")
})

app.use('/pashu/alpha/',route)
const port=5000
const start =async () => {
    try {
        await connectDB(process.env.URI)
        app.listen(port,console.log('Server is on'))    
    } catch (error) {
        console.log(error)
    }
}
start();