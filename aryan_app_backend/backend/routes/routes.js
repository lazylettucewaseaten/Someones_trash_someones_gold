const express=require('express')
const multer = require('multer');
const upload = multer();
const router=express.Router()
// <<<<<<< HEAD
const {addingnewuser ,Contact,  OTP, UpdatePassword, userverification,animalinfoaddupdate,findanimalinfo}=require('../controllers/functions')
const authHeader =require('../middleware/auth')

router.route('/adduser').post(addingnewuser)
router.route('/contactus').post(Contact);
// <<<<<<< HEAD
// router.route('/rejectwarranty').post(rejectionmail);
// =======
router.route('/OTP').post(OTP)


router.route('/UpdatePassword').post(UpdatePassword)
router.route('/loginuser').get(userverification);
router.route('/addanimalinfo').post(animalinfoaddupdate);
router.route('/getanimalinfo').get(findanimalinfo)
// >>>>>>> 27950cdf6cf580a1ff8d31ccfd84f4e542458d33

// router.route('/UpdateExpiry').post(UpdateExpiry)
                            
module.exports=router