const express=require('express')
const mongoose=require('mongoose')
const fs = require('fs');
const path = require('path');
const {musicplay}=require('../models/schema')
const multer=require('multer')
const uploadmusic=async (req,res) => {
    try{
        console.log(req.file)
        const musicf ={
            "name": req.body.name, 
            "data": req.file.buffer,     
        };
        // const task=await musicplay.create(musicf)
        task = await musicplay.create(musicf);
        
        // await musicplay.save();
        res.status(200).send({ message: 'File uploaded successfully' });
    }
    catch(error){
        res.status(500).json(error) 
    }
}
const getmusic = async (req, res) => {
    try {
        const allitems = await musicplay.findById(req.params.id);

        if (!allitems) {
            return res.status(404).send('No data in database');
        }

        res.set('Content-Type', 'audio/mpeg');
        res.set('Content-Length', allitems.data.length);
        

        res.status(200).send(allitems.data);
    } catch (error) {
        console.log(error);
        res.status(500).send(error);
    }
};
const getallmusic = async (req, res) => {
    try {
        const allitems = await musicplay.find({});

        if (!allitems || allitems.length === 0) {
            return res.status(404).send('No data in database');
        }
        const songData = allitems.map(item => ({
            id: item._id,  
            name: item.name,
        }));

        res.status(200).json(songData);
    } catch (error) {
        console.log(error);
        res.status(500).send(error);
    }
};
module.exports={uploadmusic,getmusic,getallmusic}
