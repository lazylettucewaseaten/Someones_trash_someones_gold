const mongoose=require('mongoose')
const mediafiles=mongoose.Schema({
    name:{
        type:String,
        required:true,
    },
    data:{
        type:Buffer,
        required:true,
    },
    mimetype:{
        type:String
    }
})
module.exports = {
    mediafiles: mongoose.model('mediafiles', mediafiles),
};