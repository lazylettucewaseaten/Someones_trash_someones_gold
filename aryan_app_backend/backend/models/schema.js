const mongoose=require('mongoose')
const userSchema=mongoose.Schema({
    username:{
        type:String,
        required:true,
    },
    email:{
        type:String,
        required:true,
    },
    password:{
        type:String,
        required:true,
    }
})
const animalDataSchema=mongoose.Schema({
    blood_pressure:{
        type:Number,
    },
    temperature:{
        type:Number,
    },
    strava:{
        type:String,
    },
    season:{
        type:String,
    },
    lactation_level:{
        type:Number
    },
    owner:{
        type:String
    }
})
// const warrantySchema =  mongoose.Schema({
    
//     status: {
//       type: String,
//       enum: ['Pending Verification', 'Verified', 'Expired' ,'Cancelled'],
//       default: 'Pending Verification',
//     },
//   }); 
//Contact Us page

  const ContactUs = new mongoose.Schema({
    name:{
        type:String,
        required:true
    },
    email:{
        type:String,
        required:true
    },
    message:{
        type:String,
        required:true
    }
});

module.exports = {
    UserLogin: mongoose.model('UserLogin', userSchema),
    AnimalData: mongoose.model('AnimalData', animalDataSchema),
    ContactUs: mongoose.model('ContactUs', ContactUs)
};
