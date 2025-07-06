const express=require('express')
const router=express.Router()

const multer=require('multer')
const storage=multer.diskStorage({
    destination:function (req,file,cb){
        return cb(null,"./uploads");
    },
    filename:function(req,file,cb) {
        return cb(null,`${Date.now()}-${file.originalname}`);
    },
});
const upload=multer()


const {getfiles, uploadfiles}=require('../controllers/functions');
router.route('/getallfiles').get(getfiles)
router.post('/uploadfiles',upload.single('data'),uploadfiles)
module.exports=router