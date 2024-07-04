import { useRouter } from 'next/router';
import Link from 'next/link';
import BookDetails from '@/components/BookDetails';
import Button from '@/components/Button';
import { Book } from '@/models/library';
import { useEffect, useState } from 'react';
import { readBook, deleteBook, updateBook } from '@/services/library';

const BookDetail = () => {
  const router = useRouter();
  const { id } = router.query;
  const [book, setBook] = useState<Book | null>(null);
  const [isEditing, setIsEditing] = useState(false);
  const [editedBook, setEditedBook] = useState<Book | null>(null);

  useEffect(() => {
    const retrieveBook = async () => {
      if (typeof id === 'string') {
        const resp = await readBook(parseInt(id));
        setBook(resp);
        setEditedBook(resp);
      }
    };
    if (id) {
      retrieveBook();
    }
  }, [id]);

  if (!id || Array.isArray(id)) {
    return <h2 className="text-center text-2xl">Invalid book ID</h2>;
  }

  if (!book) {
    return <h2 className="text-center text-2xl">Book not found</h2>;
  }

  const handleEditBook = () => {
    setIsEditing(true);
  };

  const handleChange = (
    e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
  ) => {
    const { name, value } = e.target;
    setEditedBook((prevBook) => prevBook ? { ...prevBook, [name]: value } : null);
  };

  const handleSaveBook = async () => {
    if (typeof id === 'string' && editedBook) {
      try {
        await updateBook(parseInt(id), editedBook);
        setBook(editedBook);
        setIsEditing(false);
        alert('Book updated successfully');
      } catch (error) {
        console.error('Error updating book:', error);
        alert('Failed to update book');
      }
    }
  };

  const handleDeleteBook = async () => {
    if (typeof id === 'string') {
      try {
        await deleteBook(parseInt(id));
        alert('Book deleted successfully');
        router.push('/'); // Redirect to the book list after deletion
      } catch (error) {
        console.error('Error deleting book:', error);
        alert('Failed to delete book');
      }
    }
  };

  return (
    <div className="container mx-auto p-4">
      <div className="card bg-base-100 shadow-md p-4">
        <Link href="/">
          <p className="text-blue-500 hover:text-blue-700 flex items-center mb-2 text-lg">
            <svg
              className="w-4 h-4 mr-2"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth="2"
                d="M15 19l-7-7 7-7"
              ></path>
            </svg>
            Back to Book List
          </p>
        </Link>
        {isEditing && editedBook ? (
          <div>
            <input
              type="text"
              name="title"
              value={editedBook.title}
              onChange={handleChange}
              placeholder="Title"
            />
            <input
              type="text"
              name="author"
              value={editedBook.author}
              onChange={handleChange}
              placeholder="Author"
            />
            <input
              type="text"
              name="genre"
              value={editedBook.genre}
              onChange={handleChange}
              placeholder="Genre"
            />
            <input
              type="text"
              name="published_date"
              value={editedBook.published_date}
              onChange={handleChange}
              placeholder="Published Date"
            />
            <textarea
              name="description"
              value={editedBook.description}
              onChange={handleChange}
              placeholder="Description"
            />
            <Button color="primary" title="Save" onClick={handleSaveBook} />
            <Button color="secondary" title="Cancel" onClick={() => setIsEditing(false)} />
          </div>
        ) : (
          <BookDetails book={book} />
        )}
        {!isEditing && (
          <div className="flex flex-row gap-2">
            <Button color="warning" title="Edit" onClick={handleEditBook} />
            <Button color="error" title="Delete" onClick={handleDeleteBook} />
          </div>
        )}
      </div>
    </div>
  );
};

export default BookDetail;
