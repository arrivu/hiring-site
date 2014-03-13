require [
  'compiled/collections/PersonelCollection',
  'compiled/collections/AcademicsCollection',
  'compiled/collections/ExperienceCollection',
  'compiled/views/Invitations/IndexView'
  'compiled/views/Invitations/PersonelCollectionView'
  'compiled/views/Invitations/AcademicsCollectionView'
  'compiled/views/Invitations/ExperienceCollectionView'
], (PersonelCollection, AcademicsCollection,ExperienceCollection, IndexView, PersonelCollectionView, AcademicsCollectionView, ExperienceCollectionView) ->

  # Collections

  personelCollection = new PersonelCollection
  academicsCollection = new AcademicsCollection
  experienceCollection = new ExperienceCollection


  personelCollectionView = new PersonelCollectionView
    collection: personelCollection
  academicsCollectionView = new AcademicsCollectionView
      collection: academicsCollection
  experienceCollectionView = new ExperienceCollectionView
      collection: experienceCollection

  @app = new IndexView
    personelCollectionView: personelCollectionView
    academicsCollectionView: academicsCollectionView
    experienceCollectionView: experienceCollectionView
    el: '#new_form'

  @app.render()
