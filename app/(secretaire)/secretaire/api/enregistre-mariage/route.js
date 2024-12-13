import path from "path"
import { writeFile } from "fs/promises";
import executeQuery from "@/database/db";
import { v4 as uuidv4 } from 'uuid';
export async function POST(request) {
  try {
    const formData= await request.formData();
    console.log(formData)
    const nomChef = await formData.get('nomChef')
    const prenomChef = await formData.get('prenomChef');
    const dateNaissanceChef = await formData.get('dateNaissanceChef');
    const LieuNaissanceChef = await formData.get('LieuNaissanceChef');
    const CNIChef = await formData.get('CNIChef');
    const residenceChef=await formData.get('residenceChef');
    const nationaliteChef = await formData.get('nationaliteChef');
    const pereChef = await formData.get('pereChef');
    const mereChef = await formData.get('mereChef')
    const emailChef= await formData.get("emailChef") 
    const PhoneChef= await formData.get("PhoneChef") 
    const autrePersonneChef = await formData.get('autrePersonneChef');
    const autrePersonneChef2 = await formData.get('autrePersonneChef2');
    const profileChef = await formData.get('profileChef');
    //informations de conjoint 
    const nomConjoin = await formData.get('nomConjoin')
    const prenomConjoin = await formData.get('prenomConjoin');
    const datenaissanceConjoin = await formData.get('datenaissanceConjoin');
    const lieuNaissanceConjoin = await formData.get('lieuNaissanceConjoin');
    const CNIConjoin = await formData.get('CNIConjoin');
    const residenceConjoin=await formData.get('residenceConjoin');
    const nationaliteConjoin = await formData.get('nationaliteConjoin');
    const pereConjoin = await formData.get('pereConjoin');
    const mereConjoin = await formData.get('mereConjoin')
    const emailConjoin= await formData.get("emailConjoin") 
    const PhoneConjoin= await formData.get("PhoneConjoin") 
    const autrePersonneConjoin = await formData.get('autrePersonneConjoin');
    const autrePersonneConjoin2 = await formData.get('autrePersonneConjoin2');
    const profileConjoin = await formData.get('profileConjoin');
    const datemariage = await formData.get('datemariage');
    const idcommune = await formData.get('idcommune');
    const uniid = uuidv4()
    const code=Math.floor(Math.random() * 10000000)

 const bytebufferProfileChef = await profileChef.arrayBuffer()
 const bytebufferProfileConjoint= await profileConjoin.arrayBuffer()
  
      const buffer1 = await Buffer.from(bytebufferProfileChef)
      const buffer2 = await Buffer.from(bytebufferProfileConjoint)

      const pathNameChef = `./public/images/${"chefmenage"}${new Date().getTime()}${path.extname(
        profileChef.name
      )}`
      const pathNameConjoint = `./public/images/${"conjoint"}${new Date().getTime()}${path.extname(
        profileConjoin.name
      )}`
   
      const ProfileCheffilename = pathNameChef.split('./public/images/')[1]
      const ProfileConjoinfilename = pathNameConjoint.split('./public/images/')[1]
  
      writeFile(pathNameChef, buffer1)
      writeFile(pathNameConjoint, buffer2)



        const Chefmenage = await executeQuery(
            "INSERT INTO chefmenage (`uuid`, `nom`, `prenom`, `datenaissance`, `lieunaissance`, `cni`, `residence`,`nationalite`, `pere`, `mere`,`datemariage`, `email`,`telephone`, `temoin`,`temoin2`, `profile`,`idcommune`) "+
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?)",
            [uniid, nomChef, prenomChef, dateNaissanceChef, 
              LieuNaissanceChef, CNIChef, residenceChef, 
              nationaliteChef, pereChef,
              mereChef,datemariage, emailChef, 
              PhoneChef, autrePersonneChef,
              autrePersonneChef2,ProfileCheffilename,idcommune]
        );
        const conjoint = await executeQuery(
            "INSERT INTO conjoint (`uuid`, `nom`, `prenom`, `datenaissance`, `lieunaissance`, `cni`, `residence`, `nationalite`, `pere`, `mere`,`datemariage`, `email`, `telephone`, `temoin`,`temoin2`, `profile`,`idcommune`) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?)",
            [uniid, nomConjoin, prenomConjoin, 
              datenaissanceConjoin, lieuNaissanceConjoin,
               CNIConjoin, residenceConjoin, nationaliteConjoin, pereConjoin,
              mereConjoin,datemariage, emailConjoin, 
              PhoneConjoin, autrePersonneConjoin,
              autrePersonneConjoin2,ProfileConjoinfilename,idcommune]
        );

      if (Chefmenage && conjoint) { 
        return new Response({message:"success"});
  } 
  else{
    return new Response({message:"error"});
  }
} 
    catch (error) {
      console.error('Erreur lors de l\'insertion dans la base de données:', error);
    return new Response("Erreur du serveur");
  } 

}




