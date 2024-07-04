import { NextPageContext } from 'next';

interface ErrorProps {
    statusCode: number;
}

const Error = ({ statusCode }: ErrorProps) => {
    return (
        <p>
            {statusCode
                ? `Oopsie daisy! An error ${statusCode} happened on the server.`
                : 'An error occurred on client'}
        </p>
    );
};

Error.getInitialProps = ({ res, err }: NextPageContext) => {
    const statusCode = res ? res.statusCode : err ? err.statusCode : 404;
    return { statusCode };
};

export default Error;